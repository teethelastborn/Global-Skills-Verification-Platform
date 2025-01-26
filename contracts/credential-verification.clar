;; Credential Verification Contract

(define-map verifications
  { credential-id: uint, verifier: principal }
  { verification-date: uint, status: (string-ascii 20) }
)

(define-public (verify-credential (credential-id uint))
  (let
    ((verifier tx-sender))
    (ok (map-set verifications
      { credential-id: credential-id, verifier: verifier }
      { verification-date: block-height, status: "verified" }
    ))
  )
)

(define-public (challenge-credential (credential-id uint) (reason (string-utf8 500)))
  (let
    ((challenger tx-sender))
    (ok (map-set verifications
      { credential-id: credential-id, verifier: challenger }
      { verification-date: block-height, status: "challenged" }
    ))
  )
)

(define-read-only (get-verification (credential-id uint) (verifier principal))
  (map-get? verifications { credential-id: credential-id, verifier: verifier })
)

(define-read-only (is-credential-verified (credential-id uint))
  (match (get-verification credential-id tx-sender)
    verification (is-eq (get status verification) "verified")
    false
  )
)

