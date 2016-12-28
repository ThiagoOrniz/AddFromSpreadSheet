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

# this method is used to format an active record into a hashmap 
# this hashmap will be sent to a firebase account
# firebase doesn't accept "." or "/"
# format will be:
# name/ name+lab_code / details
#     / name+lab_code / details
# name/ name+lab_code / details
  def self.format_all

    remedies = Remedy.all

    remedies_map = Hash.new

    remedies.each do |remedy| 
      
      details_remedy_map = Hash.new
      presentations_map = Hash.new


      remedy.presentations.each do |presentation|
        # firebase doesn't accept / or . so we replace it
        presentations_map[presentation.presentation.gsub("/"," ").gsub(".","")] = true
      end #end of presentations

      details_remedy_map = {
        "remedy_name" => remedy.name.gsub(".","").gsub("/",""),
        "lab_name" => remedy.lab_name,
        "lab_cod" => ((remedy.lab_cod.to_i).to_s),
        "lab_price" => remedy.lab_price,
        "bar_code" => remedy.code,
        "generic" => remedy.generic,
        "active_principle" =>remedy.active_principle,
        "max_price" => remedy.max_price,
        "presentations" => presentations_map
      } #endo fo map


      # get hashmap of the hash giving a key
      remedies_hash_map = remedies_map[remedy.name.gsub(".","").gsub("/","")]

      if(remedies_hash_map)
        remedies_hash_map[remedy.name.gsub(".","").gsub("/","")+""+((remedy.lab_cod.to_i).to_s)] = details_remedy_map
      
      else
        remedies_hash_map = Hash.new
        remedies_hash_map[remedy.name.gsub(".","").gsub("/","")+""+((remedy.lab_cod.to_i).to_s)] = details_remedy_map
      end

      remedies_map[remedy.name.gsub(".","").gsub("/","")] = remedies_hash_map
   
    end #end of go through all remedies

    remedies_map
  end #end of method turn into map


  def self.get_all_remedy_names

    remedies = Remedy.all
    remedies_map = Hash.new

    remedies.each do |remedy|
      remedies_map[remedy.name.gsub(".","").gsub("/","")] = true
    end
    remedies_map
  
  end

end

 

