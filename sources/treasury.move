module suprasphere::treasury {

    use std::signer;

    const E_NOT_AUTHORIZED: u64 = 1;

    /// Treasury resource stored under protocol address
    struct Treasury has key {
        total_collected: u64,
        registration_fee: u64
    }

    /// Initialize treasury (called once at deployment)
    public entry fun initialize(
        admin: &signer,
        initial_fee: u64
    ) {
        move_to(admin, Treasury {
            total_collected: 0,
            registration_fee: initial_fee
        });
    }

    /// View current registration fee
    public fun get_registration_fee(): u64 acquires Treasury {
        let treasury = borrow_global<Treasury>([@suprasphere](https://farcaster.xyz/suprasphere));
        treasury.registration_fee
    }

    /// Update registration fee (governance-controlled later)
    public entry fun update_registration_fee(
        admin: &signer,
        new_fee: u64
    ) acquires Treasury {

        let admin_addr = signer::address_of(admin);

        assert!(admin_addr == [@suprasphere](https://farcaster.xyz/suprasphere), E_NOT_AUTHORIZED);

        let treasury = borrow_global_mut<Treasury>([@suprasphere](https://farcaster.xyz/suprasphere));
        treasury.registration_fee = new_fee;
    }

    /// Collect registration fee (actual coin transfer logic later)
    public fun collect_fee(
        amount: u64
    ) acquires Treasury {

        let treasury = borrow_global_mut<Treasury>([@suprasphere](https://farcaster.xyz/suprasphere));
        treasury.total_collected = treasury.total_collected + amount;
    }
}
