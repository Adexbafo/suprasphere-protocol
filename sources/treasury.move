module suprasphere::treasury {

    struct Treasury has key {
        total_collected: u64
    }

    const REGISTRATION_FEE: u64 = 100000000000; // 1000 SUPRA

    public entry fun initialize(account: &signer) {
        move_to(account, Treasury { total_collected: 0 });
    }

    public fun record_fee() acquires Treasury {
        let treasury = borrow_global_mut<Treasury>(@suprasphere);
        treasury.total_collected =
            treasury.total_collected + REGISTRATION_FEE;
    }

    public fun get_fee(): u64 {
        REGISTRATION_FEE
    }
}


