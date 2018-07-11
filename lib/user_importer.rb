class UserImporter

  require 'roo'

  def self.importar
    xls = Roo::Spreadsheet.open("#{Rails.root}/padron.xlsx", extension: :xlsx)
    xls.each_row_streaming(offset: 1) do |row|
      hash_user = {
        nombre: row[6].cell_value,
        apellido1: "#{row[3].cell_value} #{row[2].cell_value}".strip,
        apellido2: "#{row[5].cell_value} #{row[4].cell_value}".strip,
        sexo: row[7].cell_value,
        numero_documento: "#{row[8].cell_value}#{row[9].cell_value}",
        tipo_documento: row[11].cell_value,
        fecha_nacimiento: row[14].value.to_date,
        codigo_postal: row[25].value
      }
      insertar(hash_user)
    end
  end

  def self.insertar(hash_user)
    lcr = LocalCensusRecord.find_or_initialize_by(document_number: hash_user[:numero_documento])
    lcr.document_type = hash_user[:tipo_documento]
    lcr.date_of_birth = hash_user[:fecha_nacimiento]
    lcr.postal_code = hash_user[:codigo_postal]
    lcr.save
  end


end
