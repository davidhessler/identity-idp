require 'rails_helper'

describe Reports::SpUserQuotasReport do
  subject { described_class.new }

  let(:issuer) { 'foo' }

  it 'is empty' do
    expect(subject.call).to eq('[]')
  end

  it 'runs correctly if the current month is before the fiscal start month of October' do
    expect_report_to_run_correctly_for_fiscal_start_year_month_day(2019, 9, 1)
  end

  it 'runs correctly if the current month is after the fiscal start month of October' do
    expect_report_to_run_correctly_for_fiscal_start_year_month_day(2019, 11, 1)
  end

  def expect_report_to_run_correctly_for_fiscal_start_year_month_day(year, month, day)
    ServiceProvider.create(issuer: issuer, friendly_name: issuer)
    Identity.create(user_id: 1, service_provider: issuer, uuid: 'foo1')
    Identity.create(user_id: 2, service_provider: issuer, uuid: 'foo2')
    Identity.create(user_id: 3, service_provider: issuer, uuid: 'foo3', verified_at: Time.zone.now)
    results = [{ issuer: issuer, ial2_total: 1, percent_ial2_quota: 0 }].to_json

    Timecop.travel Date.new(year, month, day) do
      expect(subject.call).to eq(results)
    end
  end
end
