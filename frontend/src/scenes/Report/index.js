import React, { useEffect, useState } from "react";

import { getSubmissions } from "../../services/submissions";

import css from "./report.module.css";

const Report = () => {
  const [submissions, setSubmissions] = useState([]);
  const [balance, setBalance] = useState(0);

  useEffect(() => {
    getSubmissions().then(newSubmissions => {
      setSubmissions(newSubmissions);
    });
  }, [setSubmissions]);

  return (
    <div className={css.host}>
      <h3>Here's what your report look like:</h3>
      <div className={css.table}>
        <div className={`${css.headers} ${css.row}`}>
          <div className={css.column}>Purchased at</div>
          <div className={css.column}>Amount (TOT)</div>
          <div className={css.column}>Amount ($)</div>
        </div>
        {submissions.map(submission => (
          <div className={css.row} key={submission.id}>
            <div className={css.column}>{submission.data.start_date}</div>
            <div className={css.column}>{submission.data.start_amount}</div>
            <div className={css.column}>{submission.data.start_dollars}</div>
          </div>
        ))}
      </div>
      <div className={css.totals}>
        <div className={css.earned}>Total earned: </div>
        <div className={css.lost}>Total lost: </div>
      </div>
    </div>
  );
};

export default Report;
