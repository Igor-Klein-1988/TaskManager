import React, { useEffect, useState } from 'react';
import KanbanBoard from '@lourenci/react-kanban';
import '@lourenci/react-kanban/dist/styles.css';
import { isEmpty } from 'ramda';

import Fab from '@material-ui/core/Fab';
import AddIcon from '@material-ui/icons/Add';

import Task from 'components/Task';
import AddPopup from 'components/AddPopup';
import EditPopup from 'components/EditPopup';
import ColumnHeader from 'components/ColumnHeader';

import TasksRepository from 'repositories/TasksRepository';

import TaskPresenter from 'presenters/TaskPresenter';
import { STATES } from 'presenters/TaskPresenter';

import TaskForm from 'forms/TaskForm';

import useTasks from 'hooks/store/useTasks';
import { useTasksActions } from 'slices/TasksSlice';

import useStyles from './useStyles';

const MODES = {
  ADD: 'add',
  EDIT: 'edit',
  NONE: 'none',
};

const PAGE = 1;
const PER_PAGE = 10;

const TaskBoard = () => {
  const styles = useStyles();
  const { board, loadBoard } = useTasks();
  const { loadColumn, loadColumnMore } = useTasksActions();
  const [mode, setMode] = useState(MODES.NONE);
  const [openedTaskId, setOpenedTaskId] = useState(null);

  const taskLoadParams = (stateEq, page = PAGE, perPage = PER_PAGE) => ({
    q: { stateEq },
    page,
    perPage,
  });

  const boardLoadParams = STATES.map(({ taskState }) => taskLoadParams(taskState));

  useEffect(() => {
    loadBoard(boardLoadParams);
  }, []);

  const handleOpenAddPopup = () => {
    setMode(MODES.ADD);
  };

  const handleOpenEditPopup = (task) => {
    setOpenedTaskId(task.id);
    setMode(MODES.EDIT);
  };

  const handleClose = () => {
    setMode(MODES.NONE);
    setOpenedTaskId(null);
  };

  const handleCardDragEnd = (task, source, destination) => {
    const transition = task.transitions.find(({ to }) => destination.toColumnId === to);
    if (!isEmpty(transition)) {
      return TasksRepository.update(TaskPresenter.id(task), { stateEvent: transition.event })
        .then(() => {
          loadColumn(taskLoadParams(destination.toColumnId));
          loadColumn(taskLoadParams(source.fromColumnId));
        })
        .catch((error) => {
          alert(`Move failed! ${error.message}`);
        });
    }

    return null;
  };

  const handleTaskCreate = (params) => {
    const attributes = TaskForm.serialize(params);

    return TasksRepository.create(attributes).then(({ data: { task } }) => {
      loadColumn(taskLoadParams(TaskPresenter.state(task)));
      handleClose();
    });
  };

  const handleTaskLoad = (id) => TasksRepository.show(id).then(({ data: { task } }) => task);

  const handleTaskUpdate = (task) => {
    const attributes = TaskForm.serialize(task);

    return TasksRepository.update(TaskPresenter.id(task), attributes).then(() => {
      loadColumn(taskLoadParams(TaskPresenter.state(task)));
      handleClose();
    });
  };

  const handleTaskDestroy = (task) =>
    TasksRepository.destroy(TaskPresenter.id(task)).then(() => {
      loadColumn(taskLoadParams(TaskPresenter.state(task)));
      handleClose();
    });

  return (
    <>
      <Fab onClick={handleOpenAddPopup} className={styles.addButton} color="primary" aria-label="add">
        <AddIcon />
      </Fab>

      <KanbanBoard
        disableColumnDrag
        onCardDragEnd={handleCardDragEnd}
        renderCard={(card) => <Task onClick={handleOpenEditPopup} task={card} />}
        renderColumnHeader={(column) => <ColumnHeader column={column} onLoadMore={loadColumnMore} />}
      >
        {board}
      </KanbanBoard>

      {mode === MODES.ADD && <AddPopup onCreateCard={handleTaskCreate} onClose={handleClose} mode={mode} />}
      {mode === MODES.EDIT && (
        <EditPopup
          onLoadCard={handleTaskLoad}
          onCardDestroy={handleTaskDestroy}
          onCardUpdate={handleTaskUpdate}
          onClose={handleClose}
          cardId={openedTaskId}
          mode={mode}
        />
      )}
    </>
  );
};

export default TaskBoard;
