1. Withdrawal from contracts

Since no funds are being held or sent by the contract, it was not necessary to implement
the safe desgin pattern that could allow an attacker to use a failing fallback function
to halt a contract's operation.

2. Restricting access

There are no admin functions that require onlyOwner or onlyBy modifiers

4. Contract Self-Destruction

As the contract will not destruct, there was no need to implement safe transfer
of any funds or restrict access to this functionality using onlyOwner modifier

5. Factory contract

Holding the addresses of each game would have been implemented in a separate
'Lobby' contract, but I did not have time to implement this.

7. Circuit Breaker

A circuit breaker was implemented in the code.

8. Reuse audited code

Reuse of audited code was used, the SafeMath contract is an example of this.
