class Remedy < ActiveRecord::Base
	has_many:presentations

	def self.import(file)

		workbook =  Roo::Excelx.new(file.path, packed: false, file_warning: :ignore)
    workbook.default_sheet = workbook.sheets[0]
    workbook.default_sheet = workbook.sheets[0]

    headers = Hash.new
    workbook.row(1).each_with_index {
        |header,i|
      	headers[header] = i
  	}

    Remedy.delete_all

    ((workbook.first_row + 1)..workbook.last_row).each do |row|


      remedy = Remedy.find_by name:(workbook.row(row)[headers['descricao_medicamento']]), lab_cod:(workbook.row(row)[headers['codigo_laboratorio']])

      if remedy
        presentation = remedy.presentations.build
        presentation.presentation = workbook.row(row)[headers['apresentacao_medicamento']]
        presentation.remedy_id = remedy.id        
        remedy.save!
      elsif 

        remedy = Remedy.new

    	  remedy.name  = workbook.row(row)[headers['descricao_medicamento']]
        remedy.lab_name  = workbook.row(row)[headers['nome_laboratorio']]
        remedy.lab_cod  = workbook.row(row)[headers['codigo_laboratorio']]
        remedy.lab_price  = workbook.row(row)[headers['preco_laboratorio']]
        remedy.code  = workbook.row(row)[headers['codigo_barras']]
        remedy.generic  = workbook.row(row)[headers['medicamento_generico']]
        remedy.active_principle  = workbook.row(row)[headers['principio_ativo']]
        remedy.max_price  = workbook.row(row)[headers['preco_maximo']]

        presentation = remedy.presentations.build

        presentation.presentation = workbook.row(row)[headers['apresentacao_medicamento']]
        presentation.remedy_id = remedy.id

        remedy.save!
      end
    end
  end
end

 

