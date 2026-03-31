module suprasphere::space {

    struct Space has key {
        id: u64,
        metadata_uri: vector<u8>,
        created_at: u64,
    }

    struct SpaceRegistry has key {
        counter: u64,
        total_spaces: u64
    }

    const SPACE_CREATION_FEE: u64 = 50000000000; // 500 SUPRA

    public entry fun initialize_registry(account: &signer) {
        move_to(account, SpaceRegistry { counter: 0, total_spaces: 0 });
    }

    public entry fun create_space(
        account: &signer,
        metadata_uri: vector<u8>,
        timestamp: u64
    ) acquires SpaceRegistry {

        let registry = borrow_global_mut<SpaceRegistry>(@suprasphere);

        registry.counter = registry.counter + 1;
        registry.total_spaces = registry.total_spaces + 1;

        move_to(account, Space {
            id: registry.counter,
            metadata_uri,
            created_at: timestamp,
        });
    }

    public fun get_space_fee(): u64 {
        SPACE_CREATION_FEE
    }
}

