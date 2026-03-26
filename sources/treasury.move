module suprasphere::treasury {

    use 0x1::signer;

    struct Treasury has key {
        total_collected: u64,
        registration_fee: u64
    }

    public entry fun initialize(
        admin: &signer,
        initial_fee: u64
    ) {
        move_to(admin, Treasury {
            total_collected: 0,
            registration_fee: initial_fee
        });
    }

    public fun get_registration_fee(): u64 acquires Treasury {
        let treasury = borrow_global<Treasury>(@suprasphere);
        treasury.registration_fee
    }

    public fun collect_fee(
        _payer: &signer,
        amount: u64
    ) acquires Treasury {

        let treasury = borrow_global_mut<Treasury>(@suprasphere);

        // Temporarily just increment accounting
        treasury.total_collected = treasury.total_collected + amount;
    }
}
