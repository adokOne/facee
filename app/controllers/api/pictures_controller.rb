class Api::PicturesController < Api::ApiController

  
  
  before_filter :set_photo ,:only=>[:info,:delete]

  def list
    total = ::Photo.where(:app_user=>$current_user.id).count
    items = ::Photo.where(:app_user=>$current_user.id).map(&:to_strim)
  	@result = {:total=>total,:items=>items}
  end

  def info
    @result =  @photo.to_json
  end

  def delete
    is_own? ? @photo.delete : (raise Api::Exception.new(7))
    FileUtils.rm_rf "#{Rails.root}/public/photos/#{$current_user.id}/#{@photo.id}"
    @result = {:success=>true}
  end

  def post
    @photo   = ::Photo.new
    params[:bd].nil?  ? (@photo.delete ; raise Api::Exception.new(15)) : @photo.update_attribute(:bd,params[:bd].to_i)
    picture = params[:photo].nil?           ? (@photo.delete ; raise Api::Exception.new(8))  : params[:photo]
    @photo.picture = picture.tempfile
    @photo.save
    @result = {:success=>true}
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

  def set_user
    id = params[:user_id] || 0
    @user = ::AppUser.where(id:id.to_i).first
    raise Api::Exception.new(9) if @user.nil?
  end


end
