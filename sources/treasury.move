module suprasphere::treasury {

    use std::signer;
    use aptos_framework::coin;
    // Note: Ensure SupraCoin is correctly defined in your dependencies
    use supra_framework::supra_coin::SupraCoin; 

    const E_NOT_AUTHORIZED: u64 = 1;

    struct Treasury has key {
        total_collected: u64,
        registration_fee: u64
    }

    /// Initialize treasury - Added a check to ensure only @suprasphere can init
    public entry fun initialize(
        admin: &signer,
        initial_fee: u64
    ) {
        let admin_addr = signer::address_of(admin);
        assert!(admin_addr == @suprasphere, E_NOT_AUTHORIZED);
        
        move_to(admin, Treasury {
            total_collected: 0,
            registration_fee: initial_fee
        });
    }

    /// Get current registration fee
    public fun get_registration_fee(): u64 acquires Treasury {
        let treasury = borrow_global<Treasury>(@suprasphere);
        treasury.registration_fee
    }

    /// Update fee (admin control)
    public entry fun update_registration_fee(
        admin: &signer,
        new_fee: u64
    ) acquires Treasury {
        let admin_addr = signer::address_of(admin);
        assert!(admin_addr == @suprasphere, E_NOT_AUTHORIZED);

        let treasury = borrow_global_mut<Treasury>(@suprasphere);
        treasury.registration_fee = new_fee;
    }

    /// Collect registration fee in real SUPRA
    public fun collect_fee(
        payer: &signer,
        amount: u64
    ) acquires Treasury {
        // Transfer SUPRA from user to protocol address
        coin::transfer<SupraCoin>(
            payer,
            @suprasphere,
            amount
        );

        let treasury = borrow_global_mut<Treasury>(@suprasphere);
        treasury.total_collected = treasury.total_collected + amount;
    }
}
