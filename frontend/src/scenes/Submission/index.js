import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

import { getSubmission } from "../../services/submissions";

import css from "./submission.module.css";

const Submission = () => {
  const params = useParams();
  const [submission, setSubmission] = useState();

  useEffect(() => {
    getSubmission(params.id).then(fetchedSubmission => {
      setSubmission(fetchedSubmission);
    });
  }, [params.id, setSubmission]);

  return (
    <div className={css.host}>
      {submission && (
        <>
          <h3 className={css.headline}>
            On <strong>{submission.data.start_date}</strong> you bought{" "}
            <strong>{submission.data.start_amount}</strong> The One Token valued
            at <strong>${submission.data.start_rate}</strong>
          </h3>
          <div className={css.resultWrapper}>
            <h3 className={css.headline}>Today it makes you a</h3>
            <div className={css.result}>
              {submission.data.delta_dollars > 0 ? `Winner` : `Loser`}
            </div>
            <span>With</span>
            <div className={css.result}>
              $ {submission.data.delta_dollars}
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export default Submission;
