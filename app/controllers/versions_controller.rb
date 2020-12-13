class VersionsController < ApplicationController
  def update_bulk
    change_stage_to = params["stage"]
    versions_ids = params["versionIds"]
    versions = Version.where(id: params["versionIds"])
    have_other_stage_version_ids = versions.filter { |version|
      version.have_stage?(change_stage_to)
    }.map { |version|
      version.id
    }
    no_version_ids = versions_ids - have_other_stage_version_ids

    if no_version_ids.count > 0
      no_versions = Version.where(id: no_version_ids).update_all(stage: change_stage_to)
    end

    if have_other_stage_version_ids.count > 0
      # Update content and Delete
      Version.where(id: have_other_stage_version_ids).destroy_all()
    end

    render status: :ok
  end

  def delete_bulk
    versions_ids = params["versionIds"]
    versions = Version.where(id: params["versionIds"])
    have_other_stage_version_ids = versions.filter { |version|
      version.have_other_stage?
    }.map { |version|
      version.id
    }
    # byebug
    versions = Version.where(id: have_other_stage_version_ids).destroy_all()
    render json: {ids: have_other_stage_version_ids}
  end
end