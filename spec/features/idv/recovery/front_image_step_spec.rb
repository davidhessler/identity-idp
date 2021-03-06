require 'rails_helper'

shared_examples 'recovery front image step' do |simulate|
  feature 'recovery front image step' do
    include IdvStepHelper
    include DocAuthHelper
    include RecoveryHelper

    let(:user) { create(:user) }
    let(:profile) { build(:profile, :active, :verified, user: user, pii: { ssn: '1234' }) }

    before do
      setup_acuant_simulator(enabled: simulate)
      sign_in_before_2fa(user)
      complete_recovery_steps_before_front_image_step(user)
      mock_assure_id_ok
    end

    it 'is on the correct page' do
      expect(page).to have_current_path(idv_recovery_front_image_step)
      expect(page).to have_content(t('doc_auth.headings.upload_front'))
    end

    it 'proceeds to the next page with valid info' do
      attach_image
      click_idv_continue

      expect(page).to have_current_path(idv_recovery_back_image_step)
    end

    it 'allows the use of a base64 encoded data url representation of the image' do
      unless simulate
        assure_id = Idv::Acuant::AssureId.new
        expect(Idv::Acuant::AssureId).to receive(:new).and_return(assure_id)
        expect(assure_id).to receive(:post_front_image).
          with(doc_auth_image_data_url_data).
          and_return([true, ''])
      end

      attach_image_data_url
      click_idv_continue

      expect(page).to have_current_path(idv_recovery_back_image_step)
    end

    it 'does not proceed to the next page with invalid info' do
      mock_assure_id_fail
      attach_image
      click_idv_continue

      expect(page).to have_current_path(idv_recovery_front_image_step)
    end
  end
end

feature 'recovery front image' do
  it_behaves_like 'recovery front image step', false
  it_behaves_like 'recovery front image step', true
end
