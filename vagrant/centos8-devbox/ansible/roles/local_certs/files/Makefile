TARGETS = jssecacerts local_trust_chain.cer

LOCAL_TRUST_CHAIN = \
	local_intermediate.cer \
	local_root.cer

.PHONY all:
all: $(TARGETS)

jssecacerts: local_intermediate.cer
	cp ${JAVA_HOME}/lib/security/cacerts jssecacerts
	keytool -importcert -keystore $@ \
		-storepass changeit -noprompt \
		-file $< \
		-alias local_intermediate

local_trust_chain.cer: $(LOCAL_TRUST_CHAIN)
	cat $^ > $@

clean:
	rm -f $(TARGETS)
