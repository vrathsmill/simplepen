class NotesController < ApplicationController

  def new
    @note = Note.new
  end

  def create
    byebug
    token = params[:headers][:token]
    @result = Auth.decode(token)
    @notebook = User.find(@result["user_id"])
    @note = Note.new(title: params[:note][:title], body: params[:note][:body], notebook_id: 1)
    byebug
    if @note.save
      render json: @note
    end
  end

  def show
    token = request.headers["token"]
    user = User.find(Auth.decode(token)["user_id"])
    note = user.notebooks.find(params[:notebook_id]).find(params[:id])
    render json: note
  end

  def index
    @notes = Note.all
    render json: @notes
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    @note.update(note_params)
    redirect_to @note
  end

  def destroy
    @note = Note.find(params[:id])
    @note.delete
    redirect_to notes_path
  end

  private

  def note_params
    params.require(:note).permit(:title, :body)
  end

end
