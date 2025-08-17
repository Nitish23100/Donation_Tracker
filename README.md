# Stack Donation Tracker

A transparent blockchain-based donation tracking system built on the Stacks blockchain using Clarity smart contracts.

## Project Description

The Stack Donation Tracker is a decentralized application that enables NGOs and charitable organizations to create fundraising projects and receive donations in a completely transparent manner. Built on the Stacks blockchain, this platform leverages the security and transparency of Bitcoin while providing smart contract functionality through Clarity.

### Key Features

- **Project Creation**: NGOs can create fundraising projects with detailed descriptions and goals
- **Transparent Donations**: All donations are recorded on-chain, ensuring complete transparency
- **Real-time Tracking**: Track total donations and project status in real-time
- **Secure Transfers**: Direct STX transfers from donors to NGO wallets
- **Project Management**: NGOs can manage project status (active/inactive)

### How It Works

1. **NGO Registration**: Organizations create projects by calling the `create-project` function
2. **Donation Process**: Donors contribute STX directly to projects using `donate-to-project`
3. **Transparency**: All transactions are recorded on the blockchain for public verification
4. **Fund Management**: Donated funds are transferred directly to NGO wallets

## Project Vision

Our vision is to revolutionize charitable giving by creating a trustless, transparent ecosystem where:

- **Donors** can verify exactly how their contributions are being used
- **NGOs** can demonstrate accountability and build trust with supporters
- **Communities** benefit from increased transparency in charitable operations
- **Blockchain Technology** serves as the foundation for a new era of transparent philanthropy

We aim to eliminate the opacity that often surrounds charitable donations, creating a world where every contribution can be tracked from donor to beneficiary, fostering greater trust and encouraging more people to participate in charitable giving.

## Future Scope

### Phase 1 - Enhanced Tracking (Q2 2024)
- **Expense Tracking**: Implement functionality for NGOs to log how funds are spent
- **Milestone System**: Allow projects to set and track fundraising milestones
- **Donor Dashboard**: Create a user interface for donors to track their contributions

### Phase 2 - Advanced Features (Q3 2024)
- **Multi-token Support**: Expand beyond STX to support other cryptocurrencies
- **Automated Reporting**: Generate automated transparency reports for stakeholders
- **Impact Metrics**: Track and display real-world impact of donations

### Phase 3 - Ecosystem Expansion (Q4 2024)
- **Mobile Application**: Develop mobile apps for iOS and Android
- **Integration APIs**: Provide APIs for third-party integrations
- **Governance Token**: Introduce community governance for platform decisions

### Phase 4 - Global Scale (2025)
- **Multi-chain Support**: Expand to other blockchain networks
- **AI-powered Insights**: Implement AI for donation optimization and fraud detection
- **Global Partnerships**: Partner with major NGOs and charitable organizations worldwide

## Contract Address

### Testnet Deployment
```
Contract Name: donation-tracker
Contract File: contracts/donationTracker.clar
Network: Stacks Testnet
```

### Mainnet Deployment
*Coming Soon - Contract will be deployed to mainnet after thorough testing*

### Contract Functions
ST24ZQMVAN7ZWGX7QXX8MFM335H6FPBMY99FH9PQG.donation-tracker
<img width="1851" height="934" alt="image" src="https://github.com/user-attachments/assets/2d274073-3264-4551-b6d2-f50a54380695" />

#### Public Functions
- `create-project(name, description)` - Create a new fundraising project
- `donate-to-project(project-id, amount)` - Donate STX to a specific project

#### Read-Only Functions
- `get-project(id)` - Retrieve project details and donation statistics

### Error Codes
- `u100` - Project not found
- `u101` - Not authorized
- `u102` - Donation amount too low
- `u103` - Project inactive

## Getting Started

### Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet) - Stacks development tool
- [Node.js](https://nodejs.org/) - For running tests
- [Stacks Wallet](https://www.hiro.so/wallet) - For interacting with the contract

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd StackDonationTracker
```

2. Install dependencies:
```bash
npm install
```

3. Run tests:
```bash
npm test
```

4. Deploy to testnet:
```bash
clarinet deployments generate --testnet
clarinet deployments apply --testnet
```

### Usage Example

```clarity
;; Create a new project
(contract-call? .donation-tracker create-project 
  "Clean Water Initiative" 
  "Providing clean water access to rural communities")

;; Donate to project ID 0
(contract-call? .donation-tracker donate-to-project u0 u1000000)

;; Get project details
(contract-call? .donation-tracker get-project u0)
```

## Contributing

We welcome contributions from the community! Please read our contributing guidelines and submit pull requests for any improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions, suggestions, or partnerships, please reach out to our team.

---

**Built with ❤️ for transparent charitable giving on the Stacks blockchain**
