module suprasphere::identity {

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

        let registry = borrow_global_mut<Registry>(@suprasphere);

        // ✅ NEW: deduct registration fee
        suprasphere::treasury::collect_fee(account);

        registry.counter = registry.counter + 1;

        move_to(account, Profile {
            username,
            reputation: 0,
            created_at: timestamp,
        });
    }
}
