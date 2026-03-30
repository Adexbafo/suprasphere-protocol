module suprasphere::treasury {

    use 0x1::coin;
    use 0x1::supra_coin::SupraCoin;

    struct Treasury has key {
        total_collected: u64
    }

    const REGISTRATION_FEE: u64 = 100000000000; // 1000 SUPRA

    public entry fun initialize(account: &signer) {
        move_to(account, Treasury { total_collected: 0 });
    }

    public fun collect_fee(account: &signer) acquires Treasury {

        let treasury = borrow_global_mut<Treasury>(@suprasphere);

        coin::transfer<SupraCoin>(
            account,
            @suprasphere,
            REGISTRATION_FEE
        );

        treasury.total_collected =
            treasury.total_collected + REGISTRATION_FEE;
    }
}
