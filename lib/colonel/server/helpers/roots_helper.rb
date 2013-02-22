module RootsHelper
  def new_path
    '/new'
  end

  def edit_path(id)
    "/edit/#{id}"
  end

  def update_path(id)
    "/#{id}"
  end

  def delete_path(id)
    "/#{id}"
  end

  def index_path
    "/"
  end

  def create_path
    "/"
  end
end
