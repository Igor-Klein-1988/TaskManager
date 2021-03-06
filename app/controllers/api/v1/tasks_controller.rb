class Api::V1::TasksController < Api::V1::ApplicationController
  def index
    q = Task.includes([:author, :assignee]).all.ransack(ransack_params)
    q.sorts = RANSACK_DEFAULT_SORT
    tasks = q.
      result.
      page(page).
      per(per_page)

    respond_with(tasks, each_serializer: TaskSerializer, root: 'tasks', meta: build_meta(tasks))
  end

  def show
    task = Task.find(params[:id])

    respond_with(task, serializer: TaskSerializer)
  end

  def create
    task = current_user.my_tasks.new(task_params)

    if task.save
      UserMailer.with({ email: current_user.email, task: task }).task_created.deliver_now
    end

    respond_with(task, serializer: TaskSerializer, location: nil)
  end

  def update
    task = Task.find(params[:id])

    if task.update(task_params)
      UserMailer.with({ email: task.author.email, task: task }).task_updated.deliver_now
    end

    respond_with(task, serializer: TaskSerializer)
  end

  def destroy
    task = Task.find(params[:id])

    if task.destroy
      UserMailer.with({ email: task.author.email, task: task }).task_deleted.deliver_now
    end

    respond_with(task)
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :author_id, :assignee_id, :state, :state_event)
  end
end
