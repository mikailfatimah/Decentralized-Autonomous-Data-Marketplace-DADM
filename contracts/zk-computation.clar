;; Zero-Knowledge Computation Contract

(define-map zk-proofs
  { dataset-id: uint, user: principal }
  { proof: (buff 64) }
)

(define-public (submit-zk-proof (dataset-id uint) (proof (buff 64)))
  (begin
    (map-set zk-proofs
      { dataset-id: dataset-id, user: tx-sender }
      { proof: proof }
    )
    (ok true)
  )
)

(define-read-only (verify-zk-proof (dataset-id uint) (user principal))
  (ok (unwrap! (map-get? zk-proofs { dataset-id: dataset-id, user: user }) (err u404)))
)

