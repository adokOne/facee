class Api::CommentController < Api::ApiController


  before_filter :set_photo ,:except=> :delete

  def list
  	@result = ::Coment.where(photo_id:@photo.id).paginate(:per_page => Settings.app.coments_limit, :page => params[:page]).map(&:to_full_api_hash)
  end


  def post
    comment = ::Coment.create(:text=>params[:text])
    comment.update_attributes(:photo=>@photo)
    list
  end

  def delete
    id    = params[:comment_id].to_i || 0
    @comment = ::Coment.where(id:id).first
    @comment.nil? ? (raise Api::Exception.new(4)) : is_own? ? @comment.delete : (raise Api::Exception.new(5))
    @result = {:success=>true}
  end


  private

  def is_own?
    $current_user.coments.include? @comment
  end

  def set_photo
    id     = params[:photo_id] || 0
    @photo = ::Photo.where(id:id.to_i).first
    raise Api::Exception.new(3) if @photo.nil?
  end


end
