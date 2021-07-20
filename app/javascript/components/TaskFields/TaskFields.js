import React from 'react';
import PropTypes from 'prop-types';
import { has } from 'ramda';

import TextField from '@material-ui/core/TextField';

import TaskPresenter from 'presenters/TaskPresenter';

import UserSelect from 'components/UserSelect';

import useStyles from './useStyles';

const MODES = {
  ADD: 'add',
  EDIT: 'edit',
};

const TaskFields = ({ errors, mode, onChange, task }) => {
  const styles = useStyles();

  const handleChangeTextField = (fieldName) => (event) => onChange({ ...task, [fieldName]: event.target.value });
  const handleChangeSelect = (fieldName) => (user) => onChange({ ...task, [fieldName]: user });
  const shouldShowAuthorField = mode === MODES.EDIT;

  return (
    <form className={styles.root}>
      <TextField
        error={has('name', errors)}
        helperText={errors.name}
        onChange={handleChangeTextField('name')}
        value={TaskPresenter.name(task)}
        label="Name"
        required
        margin="dense"
      />
      <TextField
        error={has('description', errors)}
        helperText={errors.description}
        onChange={handleChangeTextField('description')}
        value={TaskPresenter.description(task)}
        label="Description"
        required
        multiline
        margin="dense"
      />
      {shouldShowAuthorField && (
        <UserSelect
          label="Author"
          value={TaskPresenter.author(task)}
          onChange={handleChangeSelect('author')}
          isDisabled
          isRequired
          error={has('author', errors)}
          helperText={errors.author}
        />
      )}
      <UserSelect
        label="Assignee"
        value={TaskPresenter.assignee(task)}
        onChange={handleChangeSelect('assignee')}
        isRequired
        error={has('assignee', errors)}
        helperText={errors.assignee}
      />
    </form>
  );
};

TaskFields.propTypes = {
  errors: PropTypes.shape({
    name: PropTypes.arrayOf(PropTypes.string),
    description: PropTypes.arrayOf(PropTypes.string),
    author: PropTypes.arrayOf(PropTypes.string),
    assignee: PropTypes.arrayOf(PropTypes.string),
  }),
  mode: PropTypes.string.isRequired,
  onChange: PropTypes.func.isRequired,
  task: TaskPresenter.shape().isRequired,
};

TaskFields.defaultProps = {
  errors: {},
};

export default TaskFields;
