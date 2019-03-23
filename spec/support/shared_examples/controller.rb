shared_examples 'handling siren errors' do
  before { subject }

  context 'when siren is invalid' do
    let(:siren) { invalid_siren }

    it 'returns 422' do
      expect(response).to have_http_status(422)
    end

    it 'returns 422 with error message' do
      json = JSON.parse response.body

      expect(json).to include_json error: 'Le numéro siren en paramètre est mal formaté.'
    end
  end

  context 'non existent siren' do
    let(:siren) { non_existent_siren }

    it 'returns 404' do
      expect(response).to have_http_status(404)
    end

    it 'returns 404 with error message' do
      json = JSON.parse response.body

      expect(json).to include_json error: 'Aucun dossier d\'immatriculation connu pour ce siren.'
    end
  end
end
