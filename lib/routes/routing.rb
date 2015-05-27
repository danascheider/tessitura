module Sinatra
  module Tessitura
    module Routing
      def self.bulk_update(models, hashes, owner_id)
        hashes.each do |hash|
          (model = models[hashes.index(hash)]).set(hash.clean(:id, :created_at, :updated_at, :owner_id))
          raise Sequel::ValidationError unless model.valid? && model.owner_id === owner_id.to_i
        end

        models.each {|model| model.save }
      end

      def self.delete(model, id)
        return 404 unless resource = model[id]
        resource.try_rescue(:destroy) && 204 || 403
      end

      def self.get_single(model, id)
        model[id] && model[id].to_json || 404
      end

      def self.post(model, body)
        return 422 unless new_resource = model.try_rescue(:create, body)
        [201, new_resource.to_json]
      end
    end
  end
end