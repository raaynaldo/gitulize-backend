class RepositoriesController < ApplicationController
  @@options = {
    include: [:documents],
  }

  def index
    repo = Repository.first
    if repo == nil
      repo = Repository.create(name: repo, branch: "")
    end
    render json: { documents: repo.documents.as_json(include: { versions: { include: { commit: { methods: :date_to_s } } } }), repo_id: repo.id }
  end

  def show
    repo = Repository.find(params[:id])
    render json: repo
  end

  def getDocuments
    repo = Repository.find(params[:id]).documents
    render json: repo.to_json(include: { versions: { include: { commit: { methods: :date_to_s } } } })
  end

  def create
    repo = Repository.find_or_initialize_by repo_params
    if !repo.id
      repo.save
      render json: repo.to_json
    end
  end

  private

  def repo_params
    params.require(:repository).permit(:name)
  end
end
