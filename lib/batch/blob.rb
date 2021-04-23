module Batch
  class Blob
    def self.delete_unattached_blob
      puts '--- Batch::Blob.delete_unattached_blob ---'
      ActiveStorage::Blob.unattached.find_each(&:purge)
    end
  end
end