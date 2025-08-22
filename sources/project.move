module MyModule::MedicalInventory {
    use aptos_framework::signer;
    use std::string::String;
    use aptos_framework::timestamp;

    /// Struct representing a medical item in the inventory
    struct MedicalItem has store, key {
        name: String,           // Name of the medical item
        quantity: u64,          // Current quantity in stock
        expiry_date: u64,       // Expiry date (timestamp)
        batch_number: String,   // Batch number for tracking
        supplier: address,      // Address of the supplier
        last_updated: u64,      // Last update timestamp
    }

    /// Struct to hold the inventory for a medical facility
    struct Inventory has store, key {
        total_items: u64,       // Total number of different items
        facility_name: String,  // Name of the medical facility
    }

    /// Function to initialize inventory for a medical facility
    public fun initialize_inventory(
        facility_owner: &signer, 
        facility_name: String
    ) {
        let inventory = Inventory {
            total_items: 0,
            facility_name,
        };
        move_to(facility_owner, inventory);
    }

    /// Function to add a new medical item to the inventory
    public fun add_medical_item(
        facility_owner: &signer,
        name: String,
        quantity: u64,
        expiry_date: u64,
        batch_number: String,
        supplier: address
    ) acquires Inventory {
        let facility_address = signer::address_of(facility_owner);
        let inventory = borrow_global_mut<Inventory>(facility_address);
        
        // Create new medical item
        let medical_item = MedicalItem {
            name,
            quantity,
            expiry_date,
            batch_number,
            supplier,
            last_updated: timestamp::now_microseconds(),
        };
        
        // Store the medical item under a unique key (using batch number as identifier)
        move_to(facility_owner, medical_item);
        
        // Update total items count
        inventory.total_items = inventory.total_items + 1;
    }
}