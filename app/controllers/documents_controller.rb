class DocumentsController < ApplicationController
    def index
        docs = Document.all
        options = {
            include: [:repository, :commit]
          }
        render json: DocumentSerializer.new(docs, options)
    end
    
    def create
        #only find if the repo doesn't have this file
        new_doc = Document.find_or_initialize_by documentParams
        new_doc.save
        vers = new_doc.createVersion
        if vers.id == nil
            vers.save
            render json: vers
        else
            render status: 500
        end
    end

    private

    def documentParams
        params.require(:document).permit(:name, :repository_id)
    end

end
