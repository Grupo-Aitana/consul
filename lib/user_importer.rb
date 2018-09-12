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

  def self.crear_usuarios
    LocalCensusRecord.all.each do |lc|
      u = User.find_or_initialize_by(username: lc.document_number)
      u.email = "#{lc.document_number}@guadassuar.es"
      u.confirmed_at = Date.today
      u.username = "#{lc.document_number}"
      u.document_number = "#{lc.document_number}"
      u.document_type = "#{lc.document_type}"
      u.residence_verified_at = Date.today
      u.verified_at = Date.today
      u.date_of_birth = lc.date_of_birth
      u.password = u.password_confirmation = lc.date_of_birth.strftime("%d/%m/%Y")
      u.terms_of_service = "1"
      u.save
      puts u.errors.inspect
    end
  end


end
