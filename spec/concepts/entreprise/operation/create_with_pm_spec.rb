require 'rails_helper'

describe Entreprise::Operation::CreateWithPM do
  let(:create_params) do
    {
      code_greffe: '101',
      nom_greffe: 'Bourg-en-Bresse',
      numero_gestion: '2015B01079',
      siren: '813543063',
      type_inscription: 'P',
      date_immatriculation: '2015-09-17',
      date_premiere_immatriculation: '2015-09-17',
      date_radiation: '',
      date_transfert: '',
      sans_activite: '',
      date_debut_activite: '2015-10-01',
      date_debut_premiere_activite: '2015-10-01',
      date_cessation_activite: '',
      date_derniere_modification: '2015-09-17',
      libelle_derniere_modification: 'Création',
      personne_morale: {
        denomination: "MARGARITELLI FERROVIARIA",
        sigle: "",
        forme_juridique: "Société de droit étranger",
        associe_unique: nil,
        activite_principale: nil,
        type_capital: "F",
        capital: 6000000.0,
        capital_actuel: "",
        devise: "Euros",
        date_cloture: nil,
        date_cloture_exeptionnelle: nil,
        economie_sociale_solidaire: "Non",
        duree_pm: nil,
        date_derniere_modification: nil,
        libelle_derniere_modification: nil
      }
    }
  end
  subject { described_class.call(params: create_params) }

  context 'when params are valid' do
    it 'is successful' do
      expect(subject).to be_success
    end

    it 'saves the entreprise' do
      expect {subject}.to change(Entreprise, :count).by(1)
    end

    it 'saves the personne morale' do
      expect {subject}.to change(PersonneMorale, :count).by(1)
    end

    describe 'newly created entreprise' do
      let(:created_entreprise) { subject[:model] }

      it 'returns the created entreprise' do
        expect(created_entreprise.numero_gestion).to eq('2015B01079')
        expect(created_entreprise.siren).to eq('813543063')
        # TODO Continue ? ...
      end

      it 'creates the personne morale associated to the entreprise' do
        personne_morale = created_entreprise.personne_morale

        expect(personne_morale.denomination).to eq ('MARGARITELLI FERROVIARIA')
      end
    end
  end

  context 'when params are invalid' do
    let(:errors) { subject['result.contract.default'].errors[field_name] }

    describe ':siren' do
      let(:field_name) { :siren }

      it 'is required' do
        create_params[:siren] = nil

        expect(subject).to be_failure
        expect(errors).to include('must be filled')
      end
    end
  end
end
