module suprasphere::identity {

    struct SSIN has key {
        id: u64
    }

    public entry fun initialize(account: &signer) {
        move_to(account, SSIN { id: 1 });
    }
}
