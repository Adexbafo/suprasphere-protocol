module suprasphere::identity {

   use 0x1::signer;
   use 0x1::vector;
   use 0x1::string;
    use suprasphere::treasury;

    const E_ALREADY_REGISTERED: u64 = 1;

    struct SSIN has key {
        id: u64,
        username: string::String,
        pubkey: vector<u8>,
        reputation: u64,
        created_at: u64,
    }

    struct Registry has key {
        counter: u64,
        usernames: vector<string::String>,
    }

    public entry fun initialize(admin: &signer) {
        move_to(admin, Registry {
            counter: 0,
            usernames: vector::empty(),
        });
    }

    public entry fun register(
        user: &signer,
        username: string::String,
        pubkey: vector<u8>,
        timestamp: u64
    ) acquires Registry {

        let user_addr = signer::address_of(user);

        assert!(
            !exists<SSIN>(user_addr),
            E_ALREADY_REGISTERED
        );

        // Cleaned the address syntax
        let registry = borrow_global_mut<Registry>(@suprasphere);

        let fee = treasury::get_registration_fee();
        treasury::collect_fee(user, fee);

        registry.counter = registry.counter + 1;

        vector::push_back(&mut registry.usernames, username);

        move_to(user, SSIN {
            id: registry.counter,
            username,
            pubkey,
            reputation: 0,
            created_at: timestamp,
        });
    }
}
