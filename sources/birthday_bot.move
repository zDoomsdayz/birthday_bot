module overmind::birthday_bot {
    use aptos_std::table::Table;
    use std::signer;
    use std::error;
    use aptos_framework::account;
    use std::vector;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_std::table;
    use aptos_framework::timestamp;

    //
    // Errors
    //
    const ERROR_DISTRIBUTION_STORE_EXIST: u64 = 0;
    const ERROR_DISTRIBUTION_STORE_DOES_NOT_EXIST: u64 = 1;
    const ERROR_LENGTHS_NOT_EQUAL: u64 = 2;
    const ERROR_BIRTHDAY_GIFT_DOES_NOT_EXIST: u64 = 3;
    const ERROR_BIRTHDAY_TIMESTAMP_SECONDS_HAS_NOT_PASSED: u64 = 4;

    //
    // Data structures
    //
    struct BirthdayGift has drop, store {
        amount: u64,
        birthday_timestamp_seconds: u64,
    }

    struct DistributionStore has key {
        birthday_gifts: Table<address, BirthdayGift>,
        signer_capability: account::SignerCapability,
    }

    //
    // Assert functions
    //
    public fun assert_distribution_store_exists(
        account_address: address,
    ) {
        // TODO: assert that `DistributionStore` exists
        assert!(exists<DistributionStore>(account_address), ERROR_DISTRIBUTION_STORE_DOES_NOT_EXIST);
    }

    public fun assert_distribution_store_does_not_exist(
        account_address: address,
    ) {
        // TODO: assert that `DistributionStore` does not exist
        assert!(!exists<DistributionStore>(account_address), ERROR_DISTRIBUTION_STORE_EXIST);
    }

    public fun assert_lengths_are_equal(
        addresses: vector<address>,
        amounts: vector<u64>,
        timestamps: vector<u64>
    ) {
        // TODO: assert that the lengths of `addresses`, `amounts`, and `timestamps` are all equal
        assert!(vector::length(&addresses) == vector::length(&amounts), ERROR_LENGTHS_NOT_EQUAL);
        assert!(vector::length(&addresses) == vector::length(&timestamps), ERROR_LENGTHS_NOT_EQUAL);
    }

    public fun assert_birthday_gift_exists(
        distribution_address: address,
        address: address,
    ) acquires DistributionStore {
        // TODO: assert that `birthday_gifts` exists
        let store: &mut DistributionStore = borrow_global_mut<DistributionStore>(distribution_address);
        assert!(table::contains(&store.birthday_gifts, address), ERROR_BIRTHDAY_GIFT_DOES_NOT_EXIST);
    }

    public fun assert_birthday_timestamp_seconds_has_passed(
        distribution_address: address,
        address: address,
    ) acquires DistributionStore {
        // TODO: assert that the current timestamp is greater than or equal to `birthday_timestamp_seconds`
        let store: &mut DistributionStore = borrow_global_mut<DistributionStore>(distribution_address);
        let ts = table::borrow(&store.birthday_gifts, address).birthday_timestamp_seconds;
        assert!(timestamp::now_seconds() >= ts, ERROR_BIRTHDAY_TIMESTAMP_SECONDS_HAS_NOT_PASSED);
    }

    //
    // Entry functions
    //
    /**
    * Initializes birthday gift distribution contract
    * @param account - account signer executing the function
    * @param addresses - list of addresses that can claim their birthday gifts
    * @param amounts  - list of amounts for birthday gifts
    * @param birthday_timestamps - list of birthday timestamps in seconds (only claimable after this timestamp has passed)
    **/
    public entry fun initialize_distribution(
        account: &signer,
        addresses: vector<address>,
        amounts: vector<u64>,
        birthday_timestamps: vector<u64>
    ) {
        // TODO: check `DistributionStore` does not exist
        assert_distribution_store_does_not_exist(signer::address_of(account));

        // TODO: check all lengths of `addresses`, `amounts`, and `birthday_timestamps` are equal
        assert_lengths_are_equal(addresses, amounts, birthday_timestamps);

        // TODO: create resource account
        let (resource_signer, resource_capability) = account::create_resource_account(account, vector::empty<u8>());

        // TODO: register Aptos coin to resource account
        coin::register<AptosCoin>(&resource_signer);

        // TODO: loop through the lists and push items to birthday_gifts table

        // TODO: transfer the sum of all items in `amounts` from initiator to resource account

        // TODO: move_to resource `DistributionStore` to account signer
        move_to(account, DistributionStore {
            birthday_gifts: table::new(),
            signer_capability: resource_capability
        });
    }

    /**
    * Add birthday gift to `DistributionStore.birthday_gifts`
    * @param account - account signer executing the function
    * @param address - address that can claim the birthday gift
    * @param amount  - amount for the birthday gift
    * @param birthday_timestamp_seconds - birthday timestamp in seconds (only claimable after this timestamp has passed)
    **/
    public entry fun add_birthday_gift(
        account: &signer,
        address: address,
        amount: u64,
        birthday_timestamp_seconds: u64
    ) acquires DistributionStore {
        // TODO: check that the distribution store exists
        assert_distribution_store_exists(signer::address_of(account));

        // TODO: set new birthday gift to new `amount` and `birthday_timestamp_seconds` (birthday_gift already exists, sum `amounts` and override the `birthday_timestamp_seconds`

        // TODO: transfer the `amount` from initiator to resource account
        let _: &mut DistributionStore = borrow_global_mut<DistributionStore>(address);
    }

    /**
    * Remove birthday gift from `DistributionStore.birthday_gifts`
    * @param account - account signer executing the function
    * @param address - `birthday_gifts` address
    **/
    public entry fun remove_birthday_gift(
        account: &signer,
        address: address,
    ) acquires DistributionStore {
        // TODO: check that the distribution store exists
        assert_distribution_store_exists(signer::address_of(account));

        // TODO: if `birthday_gifts` exists, remove `birthday_gift` from table and transfer `amount` from resource account to initiator
        let _: &mut DistributionStore = borrow_global_mut<DistributionStore>(address);
    }

    /**
    * Claim birthday gift from `DistributionStore.birthday_gifts`
    * @param account - account signer executing the function
    * @param distribution_address - distribution contract address
    **/
    public entry fun claim_birthday_gift(
        account: &signer,
        distribution_address: address,
    ) acquires DistributionStore {
        // TODO: check that the distribution store exists
        assert_distribution_store_exists(signer::address_of(account));

        // TODO: check that the `birthday_gift` exists
        assert_birthday_gift_exists(distribution_address, signer::address_of(account));

        // TODO: check that the `birthday_timestamp_seconds` has passed
        assert_birthday_timestamp_seconds_has_passed(distribution_address, signer::address_of(account));

        // TODO: remove `birthday_gift` from table and transfer `amount` from resource account to initiator
        let _: &mut DistributionStore = borrow_global_mut<DistributionStore>(distribution_address);
    }
}
