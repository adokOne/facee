class Api::PicturesController < Api::ApiController

  before_filter :set_photo ,:only=>[:delete,:info,:like]

  def list
  	@result = ::Photo.where(:app_user=>$current_user.id).paginate(:per_page => Settings.app.photos_limit, :page => params[:page]).map{|photo| params[:full].nil? ? photo.to_json : photo.to_full_json}
  end

  def info
    @result = params[:full].nil? ?  @photo.to_full_json :  @photo.to_json
  end

  def post
    photo   = ::Photo.new
    picture = params[:photo].nil? ? (raise Api::Exception.new(8)) : params[:photo]
    photo.picture = picture.tempfile
    photo.save
    list
  end

  def strim
    @result = ::Photo.paginate(:per_page => Settings.app.photos_limit, :page => params[:page]).map{|photo| photo.to_strim}
  end

  def like
    @photo.like!
  end

  def delete
    is_own? ? @photo.delete : (raise Api::Exception.new(7))
  end


  private

  def is_own?
    $current_user.photos.include? @photo
  end

  def set_photo
    id     = params[:photo_id] || 0
    @photo = ::Photo.where(id:id.to_i).first
    raise Api::Exception.new(3) if @photo.nil?
  end

end
