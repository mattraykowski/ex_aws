if Code.ensure_loaded?(SweetXml) do
  defmodule ExAws.Beanstalk.Parsers do
    import SweetXml, only: [sigil_x: 2]

    def parse({:ok, %{body: xml}=resp}, :describe_applications) do
      parsed_body = xml
      |> SweetXml.xpath(~x"//DescribeApplicationsResponse",
        request_id: request_id_xpath(),
        applications: [
          ~x"./DescribeApplicationsResult/Applications/member"l,
          description: ~x"./Description/text()",
          application_name: ~x"./ApplicationName/text()",
          date_updated: date_xpath(:updated),
          date_created: date_xpath(:created),
          configuration_templates: ~x"./ConfigurationTemplates/member/text()"l,
          versions: ~x"./Versions/member/text()"l
        ]
      )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml}=resp}, :describe_application_versions) do
      parsed_body = xml
      |> SweetXml.xpath(~x"//DescribeApplicationVersionsResponse",
        request_id: request_id_xpath(),
        application_versions: [
          ~x"./DescribeApplicationVersionsResult/ApplicationVersions/member"l,
          version_label: ~x"./VersionLabel/text()",
          description: ~x"./Description/text()",
          application_name: ~x"./ApplicationName/text()",
          date_updated: date_xpath(:updated),
          date_created: date_xpath(:created),
          source_bundle: [
            ~x"./SourceBundle"o,
            s3_bucket: ~x"./S3Bucket/text()",
            s3_key: ~x"./S3Key/text()"
          ]
        ]
      )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml}=resp}, :describe_configuration_options) do
      parsed_body = xml
      |> SweetXml.xpath(~x"//DescribeConfigurationOptionsResponse",
        request_id: request_id_xpath(),
        solution_stack_name: ~x"./DescribeConfigurationOptionsResult/SolutionStackName/text()",
        options: [
          ~x"./DescribeConfigurationOptionsResult/Options/member"l,
          user_defined: ~x"./UserDefined/text()"s |> SweetXml.transform_by(&to_boolean/1),
          change_severity: ~x"./ChangeSeverity/text()"o,
          default_value: ~x"./DefaultValue/text()"o,
          max_length: ~x"./MaxLength/text()"o,
          max_value: ~x"./MaxValue/text()"o,
          min_value: ~x"./MinValue/text()"o,
          name: ~x"./Name/text()"o,
          namespace: ~x"./Namespace/text()"o,
          regex: [
            ~x"./Regex"o,
            label: ~x"./Label/text()"o,
            pattern: ~x"./Pattern/text()"o
          ],
          value_options: ~x"./ValueOptions/member/text()"l,
          value_type: ~x"./ValueType/text()"o
        ]
      )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml}=resp}, :describe_configuration_settings) do
      parsed_body = xml
      |> SweetXml.xpath(~x"//DescribeConfigurationSettingsResponse",
        request_id: request_id_xpath(),
        configuration_settings: [
          ~x"./DescribeConfigurationSettingsResult/ConfigurationSettings/member"l,
          solution_stack_name: ~x"./SolutionStackName/text()",
          description: ~x"./Description/text()",
          application_name: ~x"./ApplicationName/text()",
          date_updated: date_xpath(:updated),
          date_created: date_xpath(:created),
          template_name: ~x"./TemplateName/text()",
          option_settings: [
            ~x"./OptionSettings/member"l,
            option_name: ~x"./OptionName/text()",
            value: ~x"./Value/text()",
            namespace: ~x"./Namespace/text()"
          ]
        ]
      )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml}=resp}, :describe_environment_health) do
      parsed_body = xml
      |> SweetXml.xpath(~x"//DescribeEnvironmentHealthResponse",
      request_id: request_id_xpath,
      environment_health: [
        ~x"./DescribeEnvironmentHealthResult",
        health_status: ~x"./HealthStatus/text()"o,
        color: ~x"./Color/text()"o,
        status: ~x"./Status/text()"o,
        environment_name: ~x"./EnvironmentName/text()"o,
        application_metrics: [
          ~x"./ApplicationMetrics"o,
          duration: ~x"./Duration/text()"o,
          status_codes: [
            ~x"./StatusCodes"o,
            status_5xx: ~x"./Status5xx/text()"i,
            status_4xx: ~x"./Status4xx/text()"i,
            status_3xx: ~x"./Status3xx/text()"i,
            status_2xx: ~x"./Status2xx/text()"i
          ],
          latency: [
            ~x"./Latency"o,
            p90: ~x"./P90/text()"f,
            p999: ~x"./P999/text()"f,
            p99: ~x"./P99/text()"f,
            p85: ~x"./P85/text()"f,
            p50: ~x"./P50/text()"f,
            p75: ~x"./P75/text()"f,
            p95: ~x"./P95/text()"f,
            p10: ~x"./P10/text()"f
          ],
          request_count: ~x"./RequestCount/text()"i
        ],
        refreshed_at: ~x"./RefreshedAt/text()"o,
        causes: ~x"./Causes/member/text()"l,
        instances_health: [
          ~x"./InstancesHealth"o,
          degragded: ~x"./Degraded/text()"i,
          pending: ~x"./Pending/text()"i,
          ok: ~x"./Ok/text()"i,
          no_data: ~x"./NoData/text()"i,
          unknown: ~x"./Unknown/text()"i,
          severe: ~x"./Severe/text()"i,
          warning: ~x"./Warning/text()"i,
          info: ~x"./Info/text()"i
        ]
      ]
      )
      {:ok, Map.put(resp, :body, parsed_body)}
    end


    def parse({:ok, %{body: xml}=resp}, :describe_environments) do
      parsed_body = xml
      |> SweetXml.xpath(~x"//DescribeEnvironmentsResponse",
      request_id: request_id_xpath,
      environments: [
        ~x"./DescribeEnvironmentsResult/Environments/member"l,
        version_label: ~x"./VersionLabel/text()"s,
        status: ~x"./Status/text()"s,
        application_name: ~x"./ApplicationName/text()"s,
        endpoint_url: ~x"./EnvironmentURL/text()"s,
        cname: ~x"./CNAME/text()"s,
        health: ~x"./Health/text()"s,
        environment_id: ~x"./EnvironmentId/text()"s,
        date_updated: date_xpath(:updated),
        date_created: date_xpath(:created),
        solution_stack_name: ~x"./SolutionStackName/text()"s,
        description: ~x"./Description/text()"s,
        environment_name: ~x"./EnvironmentName/text()"s,
        tier: [
          ~x"./Tier"o,
          name: ~x"./Name/text()"s,
          type: ~x"./Type/text()"s,
          version: ~x"./Version/text()"so
        ],
        abortable_operation_in_progress: ~x"./AbortableOperationInProgress/text()" |> SweetXml.transform_by(&to_boolean/1),
        environment_links: [
          ~x"./EnvironmentLinks/member"l,
          environment_name: ~x"./EnvironmentName/text()"s,
          link_name: ~x"./LinkName/text()"s
        ],
        template_name: ~x"./TemplateName/text()"s
      ]
      )

      {:ok, Map.put(resp, :body, parsed_body)}
    end


    defp request_id_xpath do
      ~x"./ResponseMetadata/RequestId/text()"s
    end

    defp date_xpath(type) when type == :created, do: ~x"./DateCreated/text()"s
    defp date_xpath(type) when type == :updated, do: ~x"./DateUpdated/text()"s

    defp to_boolean(value) when value == 'true', do: true
    defp to_boolean(_), do: false
  end
else
  defmodule ExAws.Beanstalk.Parsers do
    def parse(val, _), do: val
  end
end
