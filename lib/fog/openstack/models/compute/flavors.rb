require 'fog/core/collection'
require 'fog/openstack/models/compute/flavor'

module Fog
  module Compute
    class OpenStack

      class Flavors < Fog::Collection

        model Fog::Compute::OpenStack::Flavor

        def all
          public_data = service.list_flavors_detail.body['flavors']
          # This quirk is needed because the OpenStack API does strange things and does not
          # show non-public flavors by default (even though the user would have the rights)
          # to view them
          non_public_data = service.list_flavors_detail(:is_public => false).body['flavors']
          data = (public_data + non_public_data).uniq
          load(data)
        end

        def get(flavor_id)
          data = service.get_flavor_details(flavor_id).body['flavor']
          new(data)
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

      end

    end
  end
end
