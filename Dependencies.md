# Dependencies

1. shared 
2. cluster 
3. data-persistence
4. services 

## How it works?

Stacks are distributed in levels to avoid circular dependencies. Stack in lower levels (for example `shared`) cannot use data from higher levels (for example `services`). 