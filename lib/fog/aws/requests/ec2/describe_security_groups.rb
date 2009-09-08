unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Describe all or specified security groups
        #
        # ==== Parameters
        # * group_name<~Array> - List of groups to describe, defaults to all
        #
        # === Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'securityGroupInfo'<~Array>:
        #       * 'groupDescription'<~String> - Description of security group
        #       * 'groupName'<~String> - Name of security group
        #       * 'ipPermissions'<~Array>:
        #         * 'fromPort'<~Integer> - Start of port range (or -1 for ICMP wildcard)
        #         * 'groups'<~Array>:
        #           * 'groupName'<~String> - Name of security group
        #           * 'userId'<~String> - AWS User Id of account
        #         * 'ipProtocol'<~String> - Ip protocol, must be in ['tcp', 'udp', 'icmp']
        #         * 'ipRanges'<~Array>:
        #           * 'cidrIp'<~String> - CIDR range
        #         * 'toPort'<~Integer> - End of port range (or -1 for ICMP wildcard)
        #       * 'ownerId'<~String> - AWS Access Key Id of the owner of the security group
        def describe_security_groups(group_name = [])
          params = indexed_params('GroupName', group_name)
          request({
            'Action' => 'DescribeSecurityGroups',
          }.merge!(params), Fog::Parsers::AWS::EC2::DescribeSecurityGroups.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def describe_security_groups(group_name = [])
          response = Fog::Response.new
          group_name = [*group_name]
          if group_name != []
            security_group_info = Fog::AWS::EC2.data[:security_groups].reject {|key, value| !group_name.include?(key)}.values
          else
            security_group_info = Fog::AWS::EC2.data[:security_groups].values
          end
          if group_name.length == 0 || group_name.length == security_group_info.length
            response.status = 200
            response.body = {
              'requestId'         => Fog::AWS::Mock.request_id,
              'securityGroupInfo' => security_group_info
            }
          else
            response.status = 400
            raise(Fog::Errors.status_error(200, 400, response))
          end
          response
        end

      end
    end
  end

end