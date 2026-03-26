module suprasphere::treasury {

    struct Treasury has key {
        total_collected: u64
    }

    public entry fun initialize(account: &signer) {
        move_to(account, Treasury { total_collected: 0 });
    }
}
