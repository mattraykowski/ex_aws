defmodule ExAws.Beanstalk.ParserTest do
  use ExUnit.Case, async: true
  alias ExAws.Beanstalk.Parsers
  import SweetXml, only: [sigil_x: 2]

  def to_success(doc) do
    {:ok, %{body: doc}}
  end

  def to_error(doc) do
    {:error, {:http_error, 403, doc}}
  end

  test "#parsing a describe applications response" do
    rsp = """
    <DescribeApplicationsResponse xmlns="https://elasticbeanstalk.amazonaws.com/docs/2010-12-01/">
      <DescribeApplicationsResult>
        <Applications>
          <member>
            <Versions/>
            <Description>Sample Description</Description>
            <ApplicationName>SampleApplication</ApplicationName>
            <DateCreated>2010-11-16T20:20:51.974Z</DateCreated>
            <DateUpdated>2010-11-16T20:20:51.974Z</DateUpdated>
            <ConfigurationTemplates>
              <member>Default</member>
            </ConfigurationTemplates>
          </member>
        </Applications>
      </DescribeApplicationsResult>
      <ResponseMetadata>
        <RequestId>577c70ff-f1d7-11df-8a78-9f77047e0d0c</RequestId>
      </ResponseMetadata>
    </DescribeApplicationsResponse>
    """
    |> to_success

    {:ok, %{body: parsed_doc}} = Parsers.parse(rsp, :describe_applications)
    assert parsed_doc[:request_id] == "577c70ff-f1d7-11df-8a78-9f77047e0d0c"
  end

  test "#parsing a describe application versions response" do
    rsp = """
    <DescribeApplicationVersionsResponse xmlns="https://elasticbeanstalk.amazonaws.com/docs/2010-12-01/">
      <DescribeApplicationVersionsResult>
        <ApplicationVersions>
          <member>
            <SourceBundle>
              <S3Bucket>amazonaws.com</S3Bucket>
              <S3Key>sample.war</S3Key>
            </SourceBundle>
            <VersionLabel>Version1</VersionLabel>
            <Description>description</Description>
            <ApplicationName>SampleApp</ApplicationName>
            <DateCreated>2010-11-17T03:21:59.161Z</DateCreated>
            <DateUpdated>2010-11-17T03:21:59.161Z</DateUpdated>
            <Status>UNPROCESSED</Status>
          </member>
        </ApplicationVersions>
      </DescribeApplicationVersionsResult>
      <ResponseMetadata>
        <RequestId>773cd80a-f26c-11df-8a78-9f77047e0d0c</RequestId>
      </ResponseMetadata>
    </DescribeApplicationVersionsResponse>
    """
    |> to_success

    {:ok, %{body: parsed_doc}} = Parsers.parse(rsp, :describe_application_versions)
    assert parsed_doc[:request_id] == "773cd80a-f26c-11df-8a78-9f77047e0d0c"
  end

  test "#parsing a describe configuration options response" do
    rsp = """
    <DescribeConfigurationOptionsResponse xmlns="https://elasticbeanstalk.amazonaws.com/docs/2010-12-01/">
  <DescribeConfigurationOptionsResult>
    <SolutionStackName>32bit Amazon Linux running Tomcat 7</SolutionStackName>
    <Options>
      <member>
        <UserDefined>false</UserDefined>
        <ChangeSeverity>NoInterruption</ChangeSeverity>
        <Name>Unit</Name>
        <ValueOptions>
          <member>Seconds</member>
          <member>Percent</member>
          <member>Bytes</member>
          <member>Bits</member>
          <member>Count</member>
          <member>Bytes/Second</member>
          <member>Bits/Second</member>
          <member>Count/Second</member>
          <member>None</member>
        </ValueOptions>
        <ValueType>Scalar</ValueType>
        <DefaultValue>Bytes</DefaultValue>
        <Namespace>aws:autoscaling:trigger</Namespace>
      </member>
      <member>
        <UserDefined>false</UserDefined>
        <ChangeSeverity>RestartApplicationServer</ChangeSeverity>
        <MaxLength>2000</MaxLength>
        <Regex>
          <Pattern>^\S*$</Pattern>
          <Label>nospaces</Label>
        </Regex>
        <Name>Xms</Name>
        <ValueType>Scalar</ValueType>
        <DefaultValue>256m</DefaultValue>
        <Namespace>aws:elasticbeanstalk:container:tomcat:jvmoptions</Namespace>
      </member>
      <member>
        <UserDefined>false</UserDefined>
        <ChangeSeverity>NoInterruption</ChangeSeverity>
        <MinValue>2</MinValue>
        <Name>HealthyThreshold</Name>
        <ValueType>Scalar</ValueType>
        <DefaultValue>3</DefaultValue>
        <MaxValue>10</MaxValue>
        <Namespace>aws:elb:healthcheck</Namespace>
      </member>
      <member>
        <UserDefined>false</UserDefined>
        <ChangeSeverity>RestartEnvironment</ChangeSeverity>
        <MaxLength>2000</MaxLength>
        <Name>SSLCertificateId</Name>
        <ValueType>Scalar</ValueType>
        <DefaultValue/>
        <Namespace>aws:elb:loadbalancer</Namespace>
      </member>
    </Options>
  </DescribeConfigurationOptionsResult>
  <ResponseMetadata>
    <RequestId>e8768900-f272-11df-8a78-9f77047e0d0c</RequestId>
  </ResponseMetadata>
</DescribeConfigurationOptionsResponse>
    """
    |> to_success

    {:ok, %{body: parsed_doc}} = Parsers.parse(rsp, :describe_configuration_options)
    assert parsed_doc[:request_id] == "e8768900-f272-11df-8a78-9f77047e0d0c"
  end

  test "#parsing a describe configuration settings response" do
    rsp = """
<DescribeConfigurationSettingsResponse xmlns="https://elasticbeanstalk.amazonaws.com/docs/2010-12-01/">
  <DescribeConfigurationSettingsResult>
    <ConfigurationSettings>
      <member>
        <SolutionStackName>32bit Amazon Linux running Tomcat 7</SolutionStackName>
        <OptionSettings>
          <member>
            <OptionName>ImageId</OptionName>
            <Value>ami-f2f0069b</Value>
            <Namespace>aws:autoscaling:launchconfiguration</Namespace>
          </member>
          <member>
            <OptionName>Notification Endpoint</OptionName>
            <Value/>
            <Namespace>aws:elasticbeanstalk:sns:topics</Namespace>
          </member>
        </OptionSettings>
        <Description>Default Configuration Template</Description>
        <ApplicationName>SampleApp</ApplicationName>
        <DateCreated>2010-11-17T03:20:17.832Z</DateCreated>
        <TemplateName>Default</TemplateName>
        <DateUpdated>2010-11-17T03:20:17.832Z</DateUpdated>
      </member>
    </ConfigurationSettings>
  </DescribeConfigurationSettingsResult>
  <ResponseMetadata>
    <RequestId>4bde8884-f273-11df-8a78-9f77047e0d0c</RequestId>
  </ResponseMetadata>
</DescribeConfigurationSettingsResponse>
    """
    |> to_success

    {:ok, %{body: parsed_doc}} = Parsers.parse(rsp, :describe_configuration_settings)
    assert parsed_doc[:request_id] == "4bde8884-f273-11df-8a78-9f77047e0d0c"
  end

  test "#parsing a describe environment health response" do
    rsp = """
<DescribeEnvironmentHealthResponse xmlns='http://elasticbeanstalk.amazonaws.com/docs/2010-12-01/'>
  <DescribeEnvironmentHealthResult>
    <HealthStatus>Degraded</HealthStatus>
    <Color>Red</Color>
    <Status>Ready</Status>
    <EnvironmentName>test-1</EnvironmentName>
    <ApplicationMetrics>
      <Duration>10</Duration>
      <StatusCodes>
        <Status5xx>843</Status5xx>
        <Status4xx>0</Status4xx>
        <Status3xx>0</Status3xx>
        <Status2xx>3391</Status2xx>
      </StatusCodes>
      <Latency>
        <P90>0.002</P90>
        <P999>1.367</P999>
        <P99>0.003</P99>
        <P85>0.002</P85>
        <P50>0.001</P50>
        <P75>0.001</P75>
        <P95>0.002</P95>
        <P10>0.0</P10>
      </Latency>
      <RequestCount>4234</RequestCount>
    </ApplicationMetrics>
    <RefreshedAt>2015-08-04T01:24:34Z</RefreshedAt>
    <Causes>
      <member>19.9 % of the requests are failing with HTTP 5xx.</member>
      <member>1 instance online is below Auto Scaling group minimum size 2.</member>
    </Causes>
    <InstancesHealth>
      <Degraded>1</Degraded>
      <Pending>0</Pending>
      <Ok>0</Ok>
      <NoData>0</NoData>
      <Unknown>0</Unknown>
      <Severe>0</Severe>
      <Warning>0</Warning>
      <Info>0</Info>
    </InstancesHealth>
  </DescribeEnvironmentHealthResult>
  <ResponseMetadata>
    <RequestId>9460aa20-3a47-11e5-91c3-1f9989a744d4</RequestId>
  </ResponseMetadata>
</DescribeEnvironmentHealthResponse>
    """
    |> to_success

    {:ok, %{body: parsed_doc}} = Parsers.parse(rsp, :describe_environment_health)
    assert parsed_doc[:request_id] == "9460aa20-3a47-11e5-91c3-1f9989a744d4"
  end

  test "#parsing a describe environments response" do
    rsp = """
<DescribeEnvironmentsResponse xmlns="https://elasticbeanstalk.amazonaws.com/docs/2010-12-01/">
  <DescribeEnvironmentsResult>
    <Environments>
      <member>
        <VersionLabel>Version1</VersionLabel>
        <Status>Available</Status>
        <ApplicationName>SampleApp</ApplicationName>
        <EndpointURL>elasticbeanstalk-SampleApp-1394386994.us-east-1.elb.amazonaws.com</EndpointURL>
        <CNAME>SampleApp-jxb293wg7n.elasticbeanstalk.amazonaws.com</CNAME>
        <Health>Green</Health>
        <EnvironmentId>e-icsgecu3wf</EnvironmentId>
        <DateUpdated>2010-11-17T04:01:40.668Z</DateUpdated>
        <SolutionStackName>32bit Amazon Linux running Tomcat 7</SolutionStackName>
        <Description>EnvDescrip</Description>
        <EnvironmentName>SampleApp</EnvironmentName>
        <DateCreated>2010-11-17T03:59:33.520Z</DateCreated>
      </member>
    </Environments>
  </DescribeEnvironmentsResult>
  <ResponseMetadata>
    <RequestId>44790c68-f260-11df-8a78-9f77047e0d0c</RequestId>
  </ResponseMetadata>
</DescribeEnvironmentsResponse>
    """
    |> to_success

    {:ok, %{body: parsed_doc}} = Parsers.parse(rsp, :describe_environments)
    assert parsed_doc[:request_id] == "44790c68-f260-11df-8a78-9f77047e0d0c"
  end
end
