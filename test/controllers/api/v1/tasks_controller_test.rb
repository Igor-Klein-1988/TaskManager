require 'test_helper'

class Api::V1::TasksControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index, params: { format: :json }
    assert_response :success
  end

  test 'should get show' do
    author = create(:manager)
    task = create(:task, author: author)
    get :show, params: { id: task.id, format: :json }
    assert_response :success
  end

  test 'should post create' do
    author = create(:manager)
    sign_in(author)
    assignee = create(:developer)
    task_attributes = attributes_for(:task).merge({ assignee_id: assignee.id })
    old_task_count = Task.count

    post :create, params: { task: task_attributes, format: :json }

    assert_response :created
    assert_equal Task.count, (old_task_count + 1)
  end

  test 'should put update' do
    author = create(:manager)
    assignee = create(:developer)
    task = create(:task, author: author)
    name = 'New Name'
    task_attributes = attributes_for(:task).
      merge({ author_id: author.id, assignee_id: assignee.id, name: name }).
      stringify_keys

    patch :update, params: { id: task.id, format: :json, task: task_attributes }
    assert_response :success

    task.reload
    assert_equal task.name, name
    assert_equal task.assignee_id, assignee.id
  end

  test 'should delete destroy' do
    author = create(:manager)
    task = create(:task, author: author)
    delete :destroy, params: { id: task.id, format: :json }
    assert_response :success

    assert !Task.where(id: task.id).exists?
  end
end
