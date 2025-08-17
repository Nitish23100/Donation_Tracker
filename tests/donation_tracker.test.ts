import { describe, it, expect } from 'vitest';
import { Cl } from '@stacks/transactions';

const accounts = simnet.getAccounts();

describe('Donation Tracker Contract', () => {
  it('should create a new project successfully', () => {
    const receipt = simnet.callPublicFn(
      'donation-tracker',
      'create-project',
      [Cl.stringAscii('Education Fund'), Cl.stringAscii('Providing education for underprivileged children')],
      accounts.get('wallet_1')!
    );
    
    expect(receipt.result).toBeOk(Cl.uint(0));
  });

  it('should retrieve project details after creation', () => {
    // Create a project first
    simnet.callPublicFn(
      'donation-tracker',
      'create-project',
      [Cl.stringAscii('Health Initiative'), Cl.stringAscii('Medical aid for rural communities')],
      accounts.get('wallet_1')!
    );
    
    // Retrieve the project
    const receipt = simnet.callReadOnlyFn(
      'donation-tracker',
      'get-project',
      [Cl.uint(0)],
      accounts.get('wallet_1')!
    );
    
    expect(receipt.result).toBeOk(
      Cl.tuple({
        name: Cl.stringAscii('Health Initiative'),
        description: Cl.stringAscii('Medical aid for rural communities'),
        'ngo-wallet': Cl.principal(accounts.get('wallet_1')!),
        'total-donated': Cl.uint(0),
        'total-spent': Cl.uint(0),
        'is-active': Cl.bool(true)
      })
    );
  });

  it('should allow donations to active projects', () => {
    const ngo = accounts.get('wallet_1')!;
    const donor = accounts.get('wallet_2')!;
    
    // Create a project
    simnet.callPublicFn(
      'donation-tracker',
      'create-project',
      [Cl.stringAscii('Clean Water'), Cl.stringAscii('Providing clean water access')],
      ngo
    );
    
    // Make a donation
    const receipt = simnet.callPublicFn(
      'donation-tracker',
      'donate-to-project',
      [Cl.uint(0), Cl.uint(1000000)],
      donor
    );
    
    expect(receipt.result).toBeOk(Cl.bool(true));
    
    // Verify the donation was recorded
    const projectReceipt = simnet.callReadOnlyFn(
      'donation-tracker',
      'get-project',
      [Cl.uint(0)],
      donor
    );
    
    const projectData = projectReceipt.result.expectOk().expectTuple();
    expect(projectData['total-donated']).toBeUint(1000000);
  });

  it('should reject donations to non-existent projects', () => {
    const receipt = simnet.callPublicFn(
      'donation-tracker',
      'donate-to-project',
      [Cl.uint(999), Cl.uint(1000000)],
      accounts.get('wallet_1')!
    );
    
    expect(receipt.result).toBeErr(Cl.uint(100)); // ERR_PROJECT_NOT_FOUND
  });

  it('should reject zero donations', () => {
    // Create a project first
    simnet.callPublicFn(
      'donation-tracker',
      'create-project',
      [Cl.stringAscii('Zero Test'), Cl.stringAscii('Testing zero donations')],
      accounts.get('wallet_1')!
    );
    
    // Try to donate zero
    const receipt = simnet.callPublicFn(
      'donation-tracker',
      'donate-to-project',
      [Cl.uint(0), Cl.uint(0)],
      accounts.get('wallet_2')!
    );
    
    expect(receipt.result).toBeErr(Cl.uint(102)); // ERR_DONATION_TOO_LOW
  });

  it('should reject retrieving non-existent projects', () => {
    const receipt = simnet.callReadOnlyFn(
      'donation-tracker',
      'get-project',
      [Cl.uint(999)],
      accounts.get('wallet_1')!
    );
    
    expect(receipt.result).toBeErr(Cl.uint(100)); // ERR_PROJECT_NOT_FOUND
  });
});
