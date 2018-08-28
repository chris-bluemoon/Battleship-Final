1. Re-entrancy attack (ie when calling external functions)

...

2. Integer over/under flows

   To void any underflow or overflow integer issues, the audited SafeMath library was used.

3. Poison data, data that will update a state variable and crash the code

   Where ever a user input is required in the code, a corresponding 'require' statement is used to ensure the data received is within specific parameters.

4. Function exposure

   All variables and functions have been made private to avoid unnecessarily exposing function access or access to variables from other contracts.

5. Miners can influence the timestamp to a small degree

   The mining timestamp was not used or considered in the code to avoid any miner influence on the timestamp.

6. Powerful administrators can be a risk

   Since no funds or ETH is being held or transferred, it was not considered necessary to implement a multi-sig contract, instead, ease of management was adopted over security.

7. Cross Chain Replay attack

   Following a hard fork, there are two similar chains, running the same protocol. Transactions may be valid on both networks. This was not considered a threat for these contracts since no fork is likely in the near future.

8. Tx.origin not to be used, use tx.sender

   Since no funds were being sent or received by the contract, it was not necessary to enforce the use of tx.sender over tx.origin.

9. Gas limits

   The code has been tested for gas consumption and reviewed to ensure looping over arrays does not cause limits to be reached.

10. Data length, ensure maximum length for strings

    Where appropriate, all type variables have been limited to the minimum size for the given functionality. This ensures valuable storage consumption is limited and reduces gas costs.
