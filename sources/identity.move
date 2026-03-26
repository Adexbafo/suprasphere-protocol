
module suprasphere::identity {

    use std::signer;
    use std::vector;
    use std::string;
    use std::option;
    use suprasphere::treasury;

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

        let registry = borrow_global_mut<Registry>(@suprasphere);
        // Ensure username uniqueness
        let i = 0;
let total = vector::length(&registry.usernames);

while (i < total) {
    let existing = vector::borrow(&registry.usernames, i);
    assert!(
        *existing != username,
        E_USERNAME_TAKEN
    );
    i = i + 1;
};
⚠️ BUT — This Will Still Fail
Because Move does not allow reassignment like:

i = i + 1;
So the proper Move way is to use:

let mut i = 0;
BUT Supra Move compiler here expects explicit typing.

So the correct fix is:

✅ FINAL CORRECT VERSION
Replace:

let mut i = 0;
With:

let mut i: u64 = 0;
So the whole block becomes:

let mut i: u64 = 0;
let total = vector::length(&registry.usernames);

while (i < total) {
    let existing = vector::borrow(&registry.usernames, i);
    assert!(
        *existing != username,
        E_USERNAME_TAKEN
    );
    i = i + 1;
};
✅ Why This Works
Supra Move requires explicit typing for mutable variables.

Without
: u64
, it throws parsing error.

✅ Update identity.move
Use the same overwrite method:

cat > sources/identity.move << 'EOF'
(then paste full corrected module)

Or edit only that line carefully.

✅ Then Publish Again
supra move tool publish
Tell me once you change
let mut i = 0;
to:

let mut i: u64 = 0;
Then we retry publish.

We’re very close. 🔥





      // Get current registration fee
let fee = treasury::get_registration_fee();

// Collect fee (actual SUPRA transfer wiring later)
treasury::collect_fee(user, fee);
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
