import React, { useState } from "react";
import { useHistory } from "react-router-dom";
import ReactDatePicker from "react-datepicker";

import { submitPurchase } from "../../services/submissions";

import css from "./home.module.css";

const today = new Date();

const Home = () => {
  const [amount, setAmount] = useState(0);
  const [date, setDate] = useState(new Date());
  const [submitting, setSubmitting] = useState(false);
  const history = useHistory();

  const onSubmit = evt => {
    evt.preventDefault();

    setSubmitting(true);
    submitPurchase(amount, date).then(submission => {
      setSubmitting(false);
      history.push(`/${submission.id}`);
    });
  };

  return (
    <div className={css.host}>
      <h3 className={css.headline}>What type of investor are you?</h3>
      <form className={css.form} onSubmit={onSubmit}>
        <div className={css.inputContainer}>
          <div className={css.label}>Purchased amount:</div>
          <input
            type="number"
            className={css.input}
            placeholder="Insert amount..."
            value={amount}
            onChange={evt => setAmount(evt.target.value)}
          />
        </div>
        <div className={css.inputContainer}>
          <div className={css.label}>Purchase date:</div>
          <ReactDatePicker
            className={css.input}
            selected={date}
            onChange={setDate}
            dateFormat="dd/MM/yyyy"
            maxDate={today}
          />
        </div>
        <button type="submit" className={css.btn}>
          Let me know
        </button>
      </form>
    </div>
  );
};

export default Home;
