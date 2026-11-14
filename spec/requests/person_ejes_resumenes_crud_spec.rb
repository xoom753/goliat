require "rails_helper"

RSpec.describe "Person ejes resumen management", type: :request do
  let(:attributes) do
    {
      nombres: "Casey Example",
      dni: "1234567890",
      fecha_perdida_libertad: "2020-01-02",
      delitos: "Robo",
      sentencias: "Sentencia A",
      semestres_porcentuales: "20%",
      periodos_detalle: "02/01/20\t30/06/20\t180\t20%",
      tipo_porcentual: true
    }
  end

  it "lists summaries" do
    PersonEjesResumen.create!(attributes)

    get person_ejes_resumenes_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Casey Example", "Cultural.docx", "Certificados.csv")
  end

  it "prefills the new summary from a legacy person" do
    legacy_person = LegacyPerson.create!(nombres: "CASEY EXAMPLE", dni: "1234567890")
    allow(PersonDataService).to receive(:new).with(legacy_person).and_return(
      instance_double(PersonDataService, dni: "1234567890", ubicacion: "A-1", fecha_detencion: Date.new(2020, 1, 2))
    )

    get new_person_ejes_resumen_path(legacy_person_id: legacy_person.id)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("CASEY EXAMPLE", "1234567890", "A-1")
  end

  it "renders the edit form for an existing summary" do
    summary = PersonEjesResumen.create!(attributes)

    get edit_person_ejes_resumen_path(summary)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Casey Example")
  end

  it "renders the new form when summary creation fails" do
    allow_any_instance_of(PersonEjesResumen).to receive(:save).and_return(false)

    post person_ejes_resumenes_path, params: {
      person_ejes_resumen: attributes
    }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Nuevo Resumen de Ejes")
  end

  it "creates a valid summary and redirects to index" do
    expect do
      post person_ejes_resumenes_path, params: { person_ejes_resumen: attributes }
    end.to change(PersonEjesResumen, :count).by(1)

    expect(response).to redirect_to(person_ejes_resumenes_path)
  end

  it "renders the edit form when summary update fails" do
    summary = PersonEjesResumen.create!(attributes)
    allow_any_instance_of(PersonEjesResumen).to receive(:save).and_return(false)

    patch person_ejes_resumen_path(summary), params: {
      person_ejes_resumen: attributes.merge(nombres: "Updated Example")
    }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Algo salió mal")
  end

  it "updates a summary and clears omitted person associations" do
    summary = PersonEjesResumen.create!(attributes.merge(people_ids: [ 1 ], legacy_people_ids: [ 2 ]))

    patch person_ejes_resumen_path(summary), params: {
      person_ejes_resumen: attributes.merge(nombres: "Updated Example", people_ids: [], legacy_people_ids: [])
    }

    expect(summary.reload.nombres).to eq("Updated Example")
    expect(summary.people_ids).to eq("")
    expect(summary.legacy_people_ids).to eq("")
    expect(response).to redirect_to(person_ejes_resumenes_path)
    expect(flash[:notice]).to eq("Actualizado")
  end
end
