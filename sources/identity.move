use suprasphere::treasury;
module suprasphere::identity {

    use std::signer;
    use std::vector;
    use std::string;
    use std::option;

    const E_ALREADY_REGISTERED: u64 = 1;
    const E_USERNAME_TAKEN: u64 = 2;

    /// Represents a Supra Social Identity
    struct SSIN has key {
        id: u64,
        username: string::String,
        pubkey: vector<u8>,
        reputation: u64,
        created_at: u64,
    }

    /// Global registry stored under protocol address
    struct Registry has key {
        counter: u64,
        usernames: vector<string::String>,
    }

    /// Event emitted when SSIN is created
    struct SSINCreatedEvent has drop, store {
        id: u64,
        owner: address,
        username: string::String,
    }

    /// Initialize protocol (only once)
    public entry fun initialize(admin: &signer) {
        move_to(admin, Registry {
            counter: 0,
            usernames: vector::empty(),
        });
    }

    /// Register new SSIN (1 per wallet)
    public entry fun register(
        user: &signer,
        username: string::String,
        pubkey: vector<u8>,
        timestamp: u64
    ) acquires Registry {

        let user_addr = signer::address_of(user);

        // Prevent double registration
        assert!(
            !exists<SSIN>(user_addr),
            E_ALREADY_REGISTERED
        );

        let registry = borrow_global_mut<Registry>([@suprasphere](https://farcaster.xyz/suprasphere));

        // Ensure username uniqueness
        let mut i = 0;
        let total = vector::length(&registry.usernames);

        while (i < total) {
            let existing = vector::borrow(&registry.usernames, i);
            assert!(
                *existing != username,
                E_USERNAME_TAKEN
            );
            i = i + 1;
        };

        // Increment ID counter
        registry.counter = registry.counter + 1;

        // Store username
        vector::push_back(&mut registry.usernames, username);

        // Create SSIN resource
        move_to(user, SSIN {
            id: registry.counter,
            username,
            pubkey,
            reputation: 0,
            created_at: timestamp,
        });
    }
}
