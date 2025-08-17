// Type declarations for Clarinet testing environment

interface ClarityResult {
  expectOk(): any;
  expectErr(): any;
  expectTuple(): any;
}

declare global {
  const simnet: {
    getAccounts(): Map<string, string>;
    callPublicFn(
      contract: string,
      method: string,
      args: any[],
      sender: string
    ): {
      result: ClarityResult;
    };
    callReadOnlyFn(
      contract: string,
      method: string,
      args: any[],
      sender: string
    ): {
      result: ClarityResult;
    };
  };
}

export {};
