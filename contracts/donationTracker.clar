;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Transparent Donation Tracker
;; This contract allows NGOs to create fundraising projects and donors to
;; donate STX transparently.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants and Errors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-constant ERR_PROJECT_NOT_FOUND (err u100))
(define-constant ERR_NOT_AUTHORIZED (err u101))
(define-constant ERR_DONATION_TOO_LOW (err u102))
(define-constant ERR_PROJECT_INACTIVE (err u103))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; State Variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; A counter to keep track of the number of projects created.
;; This will be used to assign a unique ID to each new project.
(define-data-var project-count uint u0)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Data Maps
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This map stores all project data.
;; The key is the project ID (a uint).
;; The value is a tuple containing the project's details.
(define-map projects
  uint ;; project-id
  {
    ;; --- Core Details ---
    name: (string-ascii 64),        ;; Name of the project
    description: (string-ascii 256), ;; Detailed description
    ngo-wallet: principal,          ;; The NGO's wallet address to receive funds

    ;; --- Financials ---
    total-donated: uint,            ;; Sum of all donations received (in micro-STX)
    total-spent: uint,              ;; Sum of all expenses logged (in micro-STX)

    ;; --- Status ---
    is-active: bool                 ;; true if project is accepting donations, false if closed
  }
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Public Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; @desc allows an NGO to create a new project
;; @param name: the name of the project
;; @param description: a description of the project's goals
;; @returns (ok uint) with the new project-id
(define-public (create-project (name (string-ascii 64)) (description (string-ascii 256)))
  (let
    (
      ;; Get the ID for the new project from our counter variable
      (new-project-id (var-get project-count))

      ;; Assemble the data for the new project into a tuple
      (new-project-data
        {
          name: name,
          description: description,
          ngo-wallet: tx-sender, ;; The wallet calling this function is the owner
          total-donated: u0,     ;; Starts with 0 donations
          total-spent: u0,       ;; Starts with 0 expenses
          is-active: true        ;; Project is active for donations by default
        }
      )
    )
    ;; Store the new project data in the 'projects' map with its ID
    (map-set projects new-project-id new-project-data)

    ;; Increment the project counter for the next project
    (var-set project-count (+ new-project-id u1))

    ;; Return a success response with the new project's ID
    (ok new-project-id)
  )
)
;; @desc allows a user to donate STX to a specific project
;; @param project-id: the id of the project to donate to
;; @param amount: the amount of micro-STX to donate
;; @returns (ok bool) on success
(define-public (donate-to-project (project-id uint) (amount uint))
  (let
    (
      ;; Get the project data, or throw an error if it doesn't exist
      (project-data (unwrap! (map-get? projects project-id) ERR_PROJECT_NOT_FOUND))
    )
    ;; --- Pre-Transfer Checks ---
    ;; Ensure the project is currently active and accepting donations
    (asserts! (get is-active project-data) ERR_PROJECT_INACTIVE)
    ;; Ensure the donation amount is greater than zero
    (asserts! (> amount u0) ERR_DONATION_TOO_LOW)

    ;; --- STX Transfer ---
    ;; Transfer the STX from the donor (tx-sender) to the NGO's wallet
    (try! (stx-transfer? amount tx-sender (get ngo-wallet project-data)))

    ;; --- Update State ---
    ;; Calculate the new total donation amount
    (let
      (
        (new-total (+ (get total-donated project-data) amount))
        (updated-project-data (merge project-data {total-donated: new-total}))
      )
      ;; Save the updated project data back to the map
      (map-set projects project-id updated-project-data)
    )

    ;; Return success
    (ok true)
  )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read-Only Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; @desc gets the details for a specific project
;; @param id: the uint ID of the project to fetch
;; @returns (response (tuple ...) (error ...))
(define-read-only (get-project (id uint))
  (match (map-get? projects id)
    project-data
    (ok project-data)
    ERR_PROJECT_NOT_FOUND
  )
)
