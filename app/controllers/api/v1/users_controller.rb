class Api::V1::UsersController < Api::V1::ApplicationController
  def index
    q = User.all.ransack(ransack_params)
    q.sorts = RANSACK_DEFAULT_SORT
    users = q.
      result.
      page(page).
      per(per_page)
    # order(:first_name)

    respond_with(users, each_serializer: UserSerializer, meta: build_meta(users), root: 'users')
  end

  def show
    user = User.find(params[:id])

    respond_with(user, serializer: UserSerializer)
  end
end
