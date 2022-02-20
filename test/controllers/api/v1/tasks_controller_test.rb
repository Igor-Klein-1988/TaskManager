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
    author = create(:user)
    sign_in(author)
    assignee = create(:user)
    task_attributes = attributes_for(:task).merge({ assignee_id: assignee.id })
    old_task_count = Task.count

    assert_emails 1 do
      post :create, params: { task: task_attributes, format: :json }
    end
    assert_response :created
    assert_equal Task.count, (old_task_count + 1)

    data = JSON.parse(response.body)
    created_task = Task.find(data['task']['id'])

    assert created_task.present?
    assert created_task.assignee == assignee
    assert created_task.author == author
  end

  test 'should put update' do
    task = create(:task)
    new_name = 'New Name'

    assert_emails 1 do
      put :update, params: { id: task.id, task: { name: new_name }, format: :json }
    end
    assert_response :success

    task.reload
    assert_equal task.name, new_name
  end

  test 'should delete destroy' do
    author = create(:manager)
    task = create(:task, author: author)

    delete :destroy, params: { id: task.id, format: :json }
    assert_response :success

    assert !Task.where(id: task.id).exists?
  end
end
