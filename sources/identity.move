module suprasphere::identity {
    use std::signer;

    /// Resources
    struct SSIN has key {
        id: u64
    }

    struct Profile has key {
        username: vector<u8>,
        reputation: u64,
        created_at: u64,
    }

    struct Registry has key {
        counter: u64
    }

    /// Error codes
    const E_NOT_AUTHORIZED: u64 = 1;

    public entry fun initialize(account: &signer) {
        move_to(account, SSIN { id: 1 });
    }

    public entry fun initialize_registry(account: &signer) {
        move_to(account, Registry { counter: 1 });
    }

    public entry fun register(
        account: &signer,
        username: vector<u8>,
        timestamp: u64
    ) acquires Registry {
        // Corrected the global borrow syntax. 
        // Replaced the placeholder with a standard address literal.
        let registry_addr = @suprasphere; 
        let registry = borrow_global_mut<Registry>(registry_addr);

        registry.counter = registry.counter + 1;

        move_to(account, Profile {
            username,
            reputation: 0,
            created_at: timestamp,
        });
    }
}
